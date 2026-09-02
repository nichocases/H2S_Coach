from collections.abc import Iterator
from datetime import UTC, datetime
from uuid import uuid4

import pytest
from fastapi.testclient import TestClient

from app.api.v1.sync import get_sync_processor
from app.main import create_app
from app.services.sync import InMemorySyncProcessor


@pytest.fixture
def client() -> Iterator[TestClient]:
    app = create_app()
    processor = InMemorySyncProcessor()
    app.dependency_overrides[get_sync_processor] = lambda: processor
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()


def _base_request(**overrides: object) -> dict[str, object]:
    payload: dict[str, object] = {
        "device_id": "tablet-1",
        "batch_id": str(uuid4()),
        "coaches": [],
        "teams": [],
        "players": [],
        "sessions": [],
        "session_players": [],
        "player_actions": [],
        "goalkeeper_actions": [],
    }
    payload.update(overrides)
    return payload


def _player_action(
    *,
    action_id: str | None = None,
    client_event_id: str = "evt-1",
    version: int = 1,
) -> dict[str, object]:
    return {
        "id": action_id or str(uuid4()),
        "session_id": str(uuid4()),
        "player_id": str(uuid4()),
        "action_type": "PASS",
        "chronometer_ms": 1200,
        "device_id": "tablet-1",
        "client_event_id": client_event_id,
        "created_at": datetime.now(UTC).isoformat(),
        "version": version,
    }


def test_sync_rejects_batches_larger_than_200(client: TestClient) -> None:
    payload = _base_request(
        player_actions=[
            _player_action(client_event_id=f"evt-{index}") for index in range(201)
        ]
    )

    response = client.post("/api/v1/sync", json=payload)

    assert response.status_code == 422


def test_sync_accepts_then_marks_replay_duplicate(client: TestClient) -> None:
    action = _player_action()
    first = client.post("/api/v1/sync", json=_base_request(player_actions=[action]))
    second = client.post("/api/v1/sync", json=_base_request(player_actions=[action]))

    assert first.status_code == 200
    assert first.json()["results"][0]["status"] == "ACCEPTED"
    assert second.status_code == 200
    assert second.json()["results"][0]["status"] == "DUPLICATE"


def test_sync_rejects_duplicate_client_event_for_different_entity(
    client: TestClient,
) -> None:
    first_action = _player_action(client_event_id="evt-shared")
    second_action = _player_action(client_event_id="evt-shared")

    client.post("/api/v1/sync", json=_base_request(player_actions=[first_action]))
    response = client.post(
        "/api/v1/sync",
        json=_base_request(player_actions=[second_action]),
    )

    result = response.json()["results"][0]
    assert response.status_code == 200
    assert result["status"] == "REJECTED"
    assert result["error_code"] == "duplicate_client_event"


def test_sync_reports_conflict_for_stale_versions(client: TestClient) -> None:
    action_id = str(uuid4())
    accepted = _player_action(
        action_id=action_id,
        client_event_id="evt-versioned",
        version=2,
    )
    stale = accepted | {"version": 1}

    client.post("/api/v1/sync", json=_base_request(player_actions=[accepted]))
    response = client.post("/api/v1/sync", json=_base_request(player_actions=[stale]))

    result = response.json()["results"][0]
    assert response.status_code == 200
    assert result["status"] == "CONFLICT"
    assert result["server_version"] == 2
