<?php

use Illuminate\Support\Facades\Route;

Route::view('/', 'welcome')->name('home');
Route::view('/checkout', 'checkout')->name('checkout');
Route::view('/offline', 'offline');

Route::get('/app', function () {
    abort_unless(app()->environment('local') && config('billing.development_bypass'), 403);

    return view('app');
})->name('app');
