/* _src/common/togglestyle.typ */

#import "/_src/mod.typ": css, js
#css.include-file("_assets/css/global.css")

// The button itself
#html.button(class: "theme-toggle", {[☀️ Light Mode]})

// The JS logic
#js.inline(```js
const toggleBtn = document.querySelector(".theme-toggle");
const root = document.documentElement;

// Restore saved theme
if (localStorage.getItem("theme") === "light") {
  root.setAttribute("data-theme", "light");
  toggleBtn.textContent = "🌙 Dark Mode";
}

toggleBtn.addEventListener("click", () => {
  if (root.getAttribute("data-theme") === "light") {
    root.removeAttribute("data-theme");
    localStorage.setItem("theme", "dark");
    toggleBtn.textContent = "☀️ Light Mode";
  } else {
    root.setAttribute("data-theme", "light");
    localStorage.setItem("theme", "light");
    toggleBtn.textContent = "🌙 Dark Mode";
  }
});
``` )
