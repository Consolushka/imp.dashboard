<?php

declare(strict_types=1);

namespace App\Infrastructure\ImpCalculator;

use App\Infrastructure\ImpCalculator\Dtos\ImpDto;
use GuzzleHttp\Client;

final readonly class ImpCalculatorConnector
{

    public function __construct(private string $baseUrl)
    {
    }

    public function imp(array $ids, array $impPers): array
    {
        $client = new Client([]);

        $idsParam = '';
        foreach ($ids as $index => $id) {
            $idsParam .= 'ids=' . $id;
            if ($index < count($ids) - 1) {
                $idsParam .= '&';
            }
        }

        $impPersParam = '';
        foreach ($impPers as $index => $impPer) {
            $impPersParam .= 'impPers=' . $impPer;
            if ($index < count($impPers) - 1) {
                $impPersParam .= '&';
            }
        }

        $resp = $client->get($this->baseUrl . '/imp?' . $idsParam . '&' . $impPersParam);
        $body = json_decode($resp->getBody()->getContents(), true);

        return array_map(fn($item) => ImpDto::fromArray($item), $body['data']);
    }
}