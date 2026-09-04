#!/bin/bash
# Script para que Vercel instale y compile Flutter automáticamente

echo "Instalando Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Verificando instalación..."
flutter --version

echo "Compilando aplicación web..."
flutter build web \
  --dart-define=API_BASE_URL=https://api-acme-b932.vercel.app \
  --dart-define=SYNC_API_BASE_URL=https://api-acme-b932.vercel.app \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
