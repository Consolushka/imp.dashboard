<?php

namespace App\Http\Controllers;

use App\Http\Requests\ImpRequest;
use App\Http\Resources\ImpResource;
use App\Infrastructure\ImpCalculator\ImpCalculatorConnector;
use Illuminate\Routing\Controller;

final class ImpController extends Controller
{
    public function __construct(private readonly ImpCalculatorConnector $connector)
    {
    }

    public function imp(ImpRequest $request)
    {
        return [
            'data' => array_map(fn($item) => ImpResource::make($item), $this->connector->imp($request->validated('ids'), $request->validated('impPers')))
        ];
    }
}
