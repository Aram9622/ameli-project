<?php

use Illuminate\Support\Facades\Route;

Route::view('/', 'welcome')->name('home');
Route::view('/checkout', 'checkout')->name('checkout');
Route::view('/offline', 'offline');