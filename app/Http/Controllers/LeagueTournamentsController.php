<?php

namespace App\Http\Controllers;

use App\Models\League;
use Illuminate\Routing\Controller;

class LeagueTournamentsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(int $leagueId)
    {
        return [
            'data' => League::find($leagueId)->tournaments
        ];
    }

    /**
     * Display the specified resource.
     */
    public function show(int $leagueId, int $tournamentId)
    {
        return [
            'data' => League::find($leagueId)->tournaments()->find($tournamentId)
        ];
    }
}
