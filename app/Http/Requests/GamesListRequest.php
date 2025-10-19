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

    public function getPerPage(): int
    {
        return $this->validated()['per_page'] ?? 15;
    }

    public function getPage(): int
    {
        return $this->validated()['page'] ?? 1;
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
            'per_page' => 'integer|min:1|max:100',
            'page' => 'integer|min:1'
        ];
    }
}