<?php

namespace App\Http\Controllers;

use App\Models\Game;
use Illuminate\Routing\Controller;

class GameStatsController extends Controller
{
    /**
     * Display the specified resource.
     */
    public function index(int $id)
    {
        return [
            'data' => Game::query()
                ->where('id', $id)
                ->with(['gameTeamStats', 'gameTeamStats.team', 'gameTeamPlayerStats', 'gameTeamPlayerStats.player'])
                ->first()
        ];
    }
}
