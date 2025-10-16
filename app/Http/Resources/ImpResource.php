<?php

namespace App\Http\Resources;

use App\Infrastructure\ImpCalculator\Dtos\ImpDto;
use App\Infrastructure\ImpCalculator\Dtos\ImpPerDto;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property ImpDto $resource
 */
class ImpResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'player_stat_id' => $this->resource->getPlayerStatId(),
            'imp_pers'       => array_map(fn(ImpPerDto $impPerData) => [
                'per' => $impPerData->getPer(),
                'imp' => $impPerData->getImp(),
            ], $this->resource->getImpPers()),
        ];
    }
}
