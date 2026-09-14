(function () {
  "use strict";

  // --- Theme toggle (initial theme is set pre-paint in the layout head) ---
  var toggle = document.querySelector(".theme-toggle");
  if (toggle) {
    toggle.addEventListener("click", function () {
      var next = document.documentElement.getAttribute("data-theme") === "dark" ? "light" : "dark";
      document.documentElement.setAttribute("data-theme", next);
      try { localStorage.setItem("tf-theme", next); } catch (e) {}
    });
  }

  // Follow OS theme changes unless the user picked one explicitly
  var mq = window.matchMedia("(prefers-color-scheme: dark)");
  mq.addEventListener("change", function (e) {
    var stored = null;
    try { stored = localStorage.getItem("tf-theme"); } catch (err) {}
    if (!stored) {
      document.documentElement.setAttribute("data-theme", e.matches ? "dark" : "light");
    }
  });

  // --- Solutions dropdown: grace period so crossing the gap to the panel
  // doesn't instantly close it (plain CSS :hover has no forgiveness here) ---
  document.querySelectorAll(".nav-dropdown").forEach(function (dd) {
    var closeTimer = null;

    function open() {
      if (closeTimer) {
        clearTimeout(closeTimer);
        closeTimer = null;
      }
      dd.classList.add("open");
    }

    function scheduleClose() {
      if (closeTimer) clearTimeout(closeTimer);
      closeTimer = setTimeout(function () {
        dd.classList.remove("open");
        closeTimer = null;
      }, 400);
    }

    dd.addEventListener("mouseenter", open);
    dd.addEventListener("mouseleave", scheduleClose);
    dd.addEventListener("focusin", open);
    dd.addEventListener("focusout", function (e) {
      if (!dd.contains(e.relatedTarget)) scheduleClose();
    });
  });

  // --- Mobile nav ---
  var navToggle = document.querySelector(".nav-toggle");
  if (navToggle) {
    navToggle.addEventListener("click", function () {
      var open = document.body.classList.toggle("nav-open");
      navToggle.setAttribute("aria-expanded", open ? "true" : "false");
      navToggle.setAttribute("aria-label", open ? "Close menu" : "Open menu");
    });
  }

  // --- Copy buttons (any element with [data-copy]) ---
  document.querySelectorAll("[data-copy]").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var text = btn.getAttribute("data-copy");
      navigator.clipboard.writeText(text).then(function () {
        var label = btn.querySelector(".copy-label");
        var original = label ? label.textContent : null;
        btn.classList.add("copied");
        if (label) label.textContent = "Copied";
        setTimeout(function () {
          btn.classList.remove("copied");
          if (label && original) label.textContent = original;
        }, 1800);
      });
    });
  });
})();
