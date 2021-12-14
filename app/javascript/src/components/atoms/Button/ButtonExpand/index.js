import React from 'react';
import { AngleDownIcon } from 'react-line-awesome';

import styles from './buttonExpand.module.scss';

const ButtonExpand = () => {
  return (
    <>
      <button className={styles['btn-expand']} type="button">
        <AngleDownIcon className={styles['las']} />
      </button>
    </>
  );
};
export default ButtonExpand;
