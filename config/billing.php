<?php

return [
    // The flag alone never grants access outside the local environment.
    'development_bypass' => env('BILLING_DEVELOPMENT_BYPASS', false),
];
