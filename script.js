document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("loginForm");
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const role = document.getElementById("role").value;
      if (role === "buyer") {
        window.location.href = "buyer.html";
      } else if (role === "seller") {
        window.location.href = "seller.html";
      } else {
        alert("Please select Buyer or Seller");
      }
    });
  }
});
