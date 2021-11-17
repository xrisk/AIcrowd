import React, { useState, useEffect } from 'react';

import styles from './scrollToTop.module.scss';

const ScrollToTop = () => {
  const [visible, setVisible] = useState(false);

  const toggleVisible = () => {
    const scrolled = document.documentElement.scrollTop;
    if (scrolled > 300) {
      setVisible(true);
    } else if (scrolled <= 300) {
      setVisible(false);
    }
  };

  const scrollToTop = e => {
    e.preventDefault();
    window.scrollTo({
      top: 0,
      behavior: 'smooth',
      /* you can also use 'auto' behaviour
         in place of 'smooth' */
    });
  };

  useEffect(() => {
    window.addEventListener('scroll', toggleVisible);

    return () => window.removeEventListener('scroll', toggleVisible);
  });

  return (
    <a className={styles['site-footer-link']} onClick={scrollToTop}>
      Back to top <i className="las la-arrow-up"></i>
    </a>
  );
};

export default ScrollToTop;
