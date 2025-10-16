<?php

namespace App\Providers;

use App\Infrastructure\ImpCalculator\ImpCalculatorConnector;
use Illuminate\Support\Facades\App;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        App::bind(ImpCalculatorConnector::class, fn() => new ImpCalculatorConnector(config('services.imp_calculator.url')));
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
