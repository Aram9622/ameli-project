import './bootstrap';
import './dashboard';

const menuButton = document.querySelector('.menu-toggle');
const navigation = document.querySelector('.main-nav');

menuButton?.addEventListener('click', () => {
    const isOpen = navigation.classList.toggle('open');
    menuButton.setAttribute('aria-expanded', String(isOpen));
});

navigation?.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
        navigation.classList.remove('open');
        menuButton?.setAttribute('aria-expanded', 'false');
    });
});

const planButtons = document.querySelectorAll('[data-plan]');
const planPrice = document.querySelector('[data-plan-price]');
const initialPlan = new URLSearchParams(window.location.search).get('plan');

function selectPlan(plan) {
    planButtons.forEach((button) => button.classList.toggle('active', button.dataset.plan === plan));

    if (planPrice) {
        planPrice.textContent = plan === 'month' ? '399 ₽ / месяц' : '2 990 ₽ / год';
    }
}

if (initialPlan === 'month' || initialPlan === 'year') {
    selectPlan(initialPlan);
}

planButtons.forEach((button) => button.addEventListener('click', () => selectPlan(button.dataset.plan)));

document.querySelector('[data-checkout-form]')?.addEventListener('submit', (event) => {
    event.preventDefault();
    const message = event.currentTarget.querySelector('.form-message');

    if (message) {
        message.hidden = false;
    }
});
