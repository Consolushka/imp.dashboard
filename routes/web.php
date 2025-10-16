<?php

use App\Http\Controllers\GamesController;
use App\Http\Controllers\GameStatsController;
use App\Http\Controllers\LeaguesController;
use App\Http\Controllers\LeagueTournamentsController;
use Illuminate\Support\Facades\Route;

Route::resource('leagues', LeaguesController::class)->only([
    'index'
]);

Route::resource('leagues.tournaments', LeagueTournamentsController::class)->only([
    'index', 'show'
]);

Route::resource('games', GamesController::class)->only([
    'index', 'show'
]);

Route::resource('games.stats', GameStatsController::class)->only([
    'index'
]);