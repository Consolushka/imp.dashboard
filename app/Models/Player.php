<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Carbon\Carbon;

class Player extends Model
{
    protected $table = 'players';

    protected $fillable = [
        'full_name',
        'birth_date_at',
    ];

    protected $casts = [
        'birth_date_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function gameTeamPlayerStats(): HasMany
    {
        return $this->hasMany(GameTeamPlayerStat::class);
    }
}
