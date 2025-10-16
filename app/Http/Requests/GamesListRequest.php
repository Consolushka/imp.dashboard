<?php

namespace App\Http\Requests;

use Carbon\Carbon;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class GamesListRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    public function getDate(): ?Carbon
    {
        if (!isset($this->validated()['date'])) {
            return null;
        }

        return Carbon::createFromFormat('Y-m-d', $this->validated()['date']);
    }

    public function getTournamentId(): ?int
    {
        return $this->validated()['tournament'] ?? null;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'date' => 'date',
            'tournament' => 'exists:tournaments,id'
        ];
    }
}
