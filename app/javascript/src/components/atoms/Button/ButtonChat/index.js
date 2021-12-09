import React from 'react';
import PropTypes from 'prop-types';

import styles from './buttonChat.module.scss';

const ButtonChat = ({ activeNumber }) => {
  return (
    <>
      <a className={styles['btn-chat']} href="/" role="button">
        <span className={styles['btn-content-left']}>Chat</span>
        <span className={styles['btn-content-right']}>{activeNumber} Online</span>
      </a>
    </>
  );
};

ButtonChat.propTypes = {
  activeNumber: PropTypes.number,
};

export default ButtonChat;
