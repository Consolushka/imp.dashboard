<?php

namespace App\Http\Controllers;

use App\Models\Tournament;
use Illuminate\Routing\Controller;

class TournamentsController extends Controller
{
    public function index()
    {
        return [
            'data' => Tournament::all()
        ];
    }
}
