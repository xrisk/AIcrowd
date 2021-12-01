import React from 'react';
import { AngleUpIcon } from 'react-line-awesome';

import styles from './buttonExpandAlt.module.scss';

const ButtonExpandAlt = () => {
  return (
    <>
      <button className={styles['btn-expand-alt']} type="button">
        <AngleUpIcon className={styles['las']} />
      </button>
    </>
  );
};
export default ButtonExpandAlt;
