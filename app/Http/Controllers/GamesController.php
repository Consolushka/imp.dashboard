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
        $builder = Game::query()
            ->with(['gameTeamStats', 'gameTeamStats.team'])
            ->orderBy('scheduled_at', 'desc');

        if ($request->getDate()) {
            $builder->whereDate('scheduled_at', $request->getDate());
        }

        return $builder->paginate(
            $request->getPerPage(),
            ['*'],
            'page',
            $request->getPage()
        );
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
