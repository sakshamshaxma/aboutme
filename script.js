// Smooth scrolling for the "Contact Me" button
document.getElementById("contact-btn").addEventListener("click", function (e) {
    e.preventDefault(); // Prevent default anchor behavior
    document.querySelector("#contact").scrollIntoView({
        behavior: "smooth"
    });
});

// Set the current year dynamically in the footer
document.getElementById("year").textContent = new Date().getFullYear();
//document.getElementById("year").textContent = new Date().getFullYear();