"""Add RBAC and RLS policies

Revision ID: 0002_rbac_and_rls
Revises: 0001_initial_schema
Create Date: 2026-09-02 21:55:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0002_rbac_and_rls'
down_revision: Union[str, None] = '0001_initial_schema'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Create a dummy auth schema and users table for local dev if not running in Supabase
    op.execute("""
    DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'auth') THEN
            EXECUTE 'CREATE SCHEMA auth';
            EXECUTE 'CREATE TABLE auth.users (id uuid PRIMARY KEY, email text)';
        END IF;
    END
    $$;
    """)

    # 2. Create the profiles table
    op.execute("""
    CREATE TABLE public.profiles (
        id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
        role text NOT NULL DEFAULT 'parent' CHECK (role IN ('super_admin', 'coach', 'parent')),
        created_at timestamptz NOT NULL DEFAULT now(),
        updated_at timestamptz NOT NULL DEFAULT now()
    );
    """)

    # 3. Create a trigger function to automatically create a profile for new users
    op.execute("""
    CREATE OR REPLACE FUNCTION public.handle_new_user() 
    RETURNS trigger AS $$
    BEGIN
      INSERT INTO public.profiles (id, role)
      VALUES (new.id, 'parent');
      RETURN new;
    END;
    $$ LANGUAGE plpgsql SECURITY DEFINER;
    """)

    # 4. Bind the trigger to auth.users
    op.execute("DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;")
    op.execute("""
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
    """)

    # 5. Enable RLS on all relevant tables
    tables = [
        'profiles',
        'teams',
        'players',
        'tournament_sessions',
        'match_actions',
        'session_players',
        'shoot_details',
        'goalkeeper_actions'
    ]
    for table in tables:
        op.execute(f"ALTER TABLE public.{table} ENABLE ROW LEVEL SECURITY;")

    # 6. Public read policies
    # Everyone (even anonymous) can read
    for table in tables:
        op.execute(f"""
        CREATE POLICY "{table}_public_read" ON public.{table}
        FOR SELECT
        USING (true);
        """)

    # 7. Write policies (INSERT, UPDATE, DELETE)
    # Only super_admin and coach can modify core tables
    core_tables = [
        'teams',
        'players',
        'tournament_sessions',
        'match_actions',
        'session_players',
        'shoot_details',
        'goalkeeper_actions'
    ]
    
    for table in core_tables:
        op.execute(f"""
        CREATE POLICY "{table}_coach_admin_all" ON public.{table}
        FOR ALL
        USING (
          EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role IN ('coach', 'super_admin')
          )
        );
        """)

    # 8. Profile write policies
    # Users can update their own profile (but role changes are handled separately)
    op.execute("""
    CREATE POLICY "profiles_update_own" ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id);
    """)

    # Super admins can do everything on profiles
    op.execute("""
    CREATE POLICY "profiles_super_admin_all" ON public.profiles
    FOR ALL
    USING (
      EXISTS (
        SELECT 1 FROM public.profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'super_admin'
      )
    );
    """)


def downgrade() -> None:
    # Drop policies
    tables = [
        'profiles',
        'teams',
        'players',
        'tournament_sessions',
        'match_actions',
        'session_players',
        'shoot_details',
        'goalkeeper_actions'
    ]
    for table in tables:
        op.execute(f"DROP POLICY IF EXISTS \"{table}_public_read\" ON public.{table};")

    core_tables = [
        'teams',
        'players',
        'tournament_sessions',
        'match_actions',
        'session_players',
        'shoot_details',
        'goalkeeper_actions'
    ]
    for table in core_tables:
        op.execute(f"DROP POLICY IF EXISTS \"{table}_coach_admin_all\" ON public.{table};")
        
    op.execute("DROP POLICY IF EXISTS \"profiles_update_own\" ON public.profiles;")
    op.execute("DROP POLICY IF EXISTS \"profiles_super_admin_all\" ON public.profiles;")

    # Disable RLS
    for table in tables:
        op.execute(f"ALTER TABLE public.{table} DISABLE ROW LEVEL SECURITY;")

    # Drop triggers and functions
    op.execute("DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;")
    op.execute("DROP FUNCTION IF EXISTS public.handle_new_user();")

    # Drop profiles
    op.execute("DROP TABLE IF EXISTS public.profiles;")
