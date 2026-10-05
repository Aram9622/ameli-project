<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ config('app.name') }}</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="flex min-h-screen items-center justify-center bg-slate-950 text-slate-100">
    <main class="text-center">
        <h1 class="text-5xl font-semibold tracking-tight">{{ config('app.name') }}</h1>
        <p class="mt-4 text-slate-400">Laravel установлен и готов к работе.</p>
    </main>
</body>
</html>
