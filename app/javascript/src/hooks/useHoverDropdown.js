import { useState, useCallback } from 'react';

// use this hook when menu dropdown needs to open & close on hover
const useHoverDropdown = delay => {
  const [mouseOverButton, setMouseOverButton] = useState(false);
  const [mouseOverMenu, setMouseOverMenu] = useState(false);

  const delayHide = delay || 300;

  const enterButton = useCallback(() => {
    setMouseOverButton(true);
  });

  const leaveButton = useCallback(() => {
    // Set a timeout so that the menu doesn't close before the user has time to
    // move their mouse over it
    setTimeout(() => {
      setMouseOverButton(false);
    }, delayHide);
  });

  const enterMenu = useCallback(() => {
    setMouseOverMenu(true);
  });

  const leaveMenu = useCallback(() => {
    setTimeout(() => {
      setMouseOverMenu(false);
    }, delayHide);
  });

  return {
    show: mouseOverButton || mouseOverMenu,
    enterButton,
    leaveButton,
    enterMenu,
    leaveMenu,
  };
};

export default useHoverDropdown;
