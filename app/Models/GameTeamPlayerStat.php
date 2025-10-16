<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Carbon\Carbon;

class GameTeamPlayerStat extends Model
{
    protected $table = 'game_team_player_stats';

    protected $fillable = [
        'game_id',
        'team_id',
        'player_id',
        'played_seconds',
        'plus_minus',
    ];

    protected $casts = [
        'played_seconds' => 'integer',
        'plus_minus' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function game(): BelongsTo
    {
        return $this->belongsTo(Game::class);
    }

    public function team(): BelongsTo
    {
        return $this->belongsTo(Team::class);
    }

    public function player(): BelongsTo
    {
        return $this->belongsTo(Player::class);
    }
}
