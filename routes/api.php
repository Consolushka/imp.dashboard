<?php

use App\Http\Controllers\ImpController;
use Illuminate\Support\Facades\Route;

Route::post('/imp', [ImpController::class, 'imp']);