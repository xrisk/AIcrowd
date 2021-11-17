import React from 'react';
import PropTypes from 'prop-types';

import styles from './logoMark.module.scss';

const LogoMark = ({ link }) => {
  return (
    <>
      <a className={styles['logomark']} href={link}>
        <span className={'sr-only'}>AIcrowd logomark</span>
      </a>
    </>
  );
};

LogoMark.propTypes = {
  link: PropTypes.string,
};

export default LogoMark;
