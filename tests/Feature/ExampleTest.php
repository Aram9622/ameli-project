<?php

namespace Tests\Feature;

use Tests\TestCase;

class ExampleTest extends TestCase
{
    public function test_the_application_returns_a_successful_response(): void
    {
        $this->get('/')->assertSuccessful();
    }

    public function test_the_checkout_page_returns_a_successful_response(): void
    {
        $this->get('/checkout')->assertSuccessful();
    }
}
