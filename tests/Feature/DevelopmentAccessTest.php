<?php

namespace Tests\Feature;

use Tests\TestCase;

class DevelopmentAccessTest extends TestCase
{
    public function test_local_development_can_skip_payment(): void
    {
        $this->app['env'] = 'local';
        config(['billing.development_bypass' => true]);
        $this->withoutVite();

        $this->get('/checkout')->assertSee('Пропустить оплату');
        $this->get('/app')->assertSuccessful()->assertSee('Оплата пропущена');
    }

    public function test_production_blocks_the_bypass_even_when_the_flag_is_enabled(): void
    {
        $this->app['env'] = 'production';
        config(['billing.development_bypass' => true]);
        $this->withoutVite();

        $this->get('/checkout')->assertDontSee('Пропустить оплату');
        $this->get('/app')->assertForbidden();
    }

    public function test_local_bypass_can_be_disabled(): void
    {
        $this->app['env'] = 'local';
        config(['billing.development_bypass' => false]);
        $this->withoutVite();

        $this->get('/checkout')->assertDontSee('Пропустить оплату');
        $this->get('/app')->assertForbidden();
    }
}
