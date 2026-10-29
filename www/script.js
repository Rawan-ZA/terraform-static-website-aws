// Select DOM elements
const button = document.getElementById('colorBtn');
const message = document.getElementById('message');

// Add click listener
button.addEventListener('click', function() {
    // Toggle element visibility
    message.classList.toggle('hidden');
    
    // Update button text based on state
    if (!message.classList.contains('hidden')) {
        button.textContent = 'Awesome!';
    } else {
        button.textContent = 'Click Me';
    }
});