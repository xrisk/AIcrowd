import React from 'react';
import cx from 'classnames';
import { PlusIcon, UndoAltIcon, GithubIcon } from 'react-line-awesome';
import { motion } from 'framer-motion';

import styles from './actionButton.module.scss';

export type ActionButtonProps = {
  size?: 'large' | 'wide' | 'default';
  type: 'add' | 'rerun' | 'github' | 'google';
  disableAnimation?: boolean;
  fontFamily?: string;
  handleClick: () => void;
};

const ActionButton = ({ type, size, disableAnimation, fontFamily, handleClick }: ActionButtonProps) => {
  const largeButton = size === 'large' ? styles.large : '';
  const wideButton = size === 'wide' ? styles.wide : '';

  const buttonText = {
    add: 'Add Round',
    rerun: 'Rerun',
    github: 'Sign Up with Github',
    google: 'Sign Up with Google',
  };

  return (
    <>
      <motion.button
        style={{ fontFamily: fontFamily }}
        className={cx(styles[`btn-${type}`], largeButton, wideButton)}
        type="button"
        whileTap={{ scale: disableAnimation ? 1 : 0.98 }}
        layout="position"
        onClick={handleClick}>
        {type === 'add' && <PlusIcon className={styles['las']} />}
        {type === 'rerun' && <UndoAltIcon className={styles['las']} />}
        {type === 'github' && <GithubIcon className={styles['lab']} />}
        {type === 'google' && <img src="https://images.aicrowd.com/images/landing_page/google.svg" width="24" height="24" alt="google logo"></img>}
        {buttonText[type]}
      </motion.button>
    </>
  );
};

export default ActionButton;
