// Based on https://www.aleksandrhovhannisyan.com/blog/how-to-add-a-copy-to-clipboard-button-to-your-jekyll-blog/
const codeBlocks = document.querySelectorAll('.copy-target');
const copyCodeButtons = document.querySelectorAll('.copy-code-button');

copyCodeButtons.forEach((copyCodeButton, index) => {
  const code = codeBlocks[index].innerText;

  copyCodeButton.addEventListener('click', () => {
    // Copy the code to the user's clipboard
    window.navigator.clipboard.writeText(code);

    // Toggle a class for styling the button
    copyCodeButton.classList.add('copied');

    // After 2 seconds, reset the button to its initial UI
    setTimeout(() => {
      copyCodeButton.classList.remove('copied');
    }, 2000);
  });
});
