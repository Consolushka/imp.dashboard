<?php

declare(strict_types=1);

namespace App\Infrastructure\ImpCalculator\Dtos;


final readonly class ImpPerDto
{
    public function __construct(
        private string $per,
        private float  $imp,
    )
    {
    }

    public static function fromArray(array $data): self
    {
        return new self(
            per: $data['per'],
            imp: $data['imp'],
        );
    }


    public function getPer(): string
    {
        return $this->per;
    }

    public function getImp(): float
    {
        return $this->imp;
    }
}