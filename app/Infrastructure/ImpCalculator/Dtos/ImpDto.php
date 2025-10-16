<?php

declare(strict_types=1);

namespace App\Infrastructure\ImpCalculator\Dtos;


final class ImpDto
{
    
    /**
     * @param int $playerStatId
     * @param ImpPerDto[] $impPers
     */
    public function __construct(
        private readonly int   $playerStatId,
        private readonly array $impPers,
    )
    {
    }

    /**
     * @param array{playerStatId: int, impPers: array} $data
     * @return self
     */
    public static function fromArray(array $data): self
    {
        if (!isset($data['playerStatId'], $data['impPers'])) {
            throw new \InvalidArgumentException('Missing required fields');
        }

        $impPers = array_map(
            fn(array $impPerData) => ImpPerDto::fromArray($impPerData),
            $data['impPers']
        );

        return new self(
            playerStatId: $data['playerStatId'],
            impPers: $impPers
        );
    }

    public function getPlayerStatId(): int
    {
        return $this->playerStatId;
    }

    /**
     * @return ImpPerDto[]
     */
    public function getImpPers(): array
    {
        return $this->impPers;
    }
}