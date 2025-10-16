<?php

namespace App\Http\Controllers;

use App\Http\Requests\GamesListRequest;
use App\Models\Game;
use Illuminate\Routing\Controller;

class GamesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(GamesListRequest $request)
    {
        $builder = Game::query();

        if ($request->getTournamentId())
            $builder->where('tournament_id', $request->getTournamentId());

        if ($request->getDate())
            $builder->whereDate('scheduled_at', $request->getDate());

        return [
            'data' => $builder->get()
        ];
    }

    /**
     * Display the specified resource.
     */
    public function show(int $id)
    {
        return [
            'data' => Game::query()
                ->where('id', $id)
                ->first()
        ];
    }
}
