import React from 'react';
import { HeartIcon } from 'react-line-awesome';
import PropTypes from 'prop-types';

import styles from './buttonLike.module.scss';

const ButtonLike = ({ likeCount }) => {
  return (
    <>
      <button className={styles['btn-like']} type="button" aria-label="Like" data-balloon-pos="up">
        <HeartIcon className={styles['las']} />
        <span className={styles['like-counter']}>{likeCount}</span>
      </button>
    </>
  );
};

ButtonLike.propTypes = {
  likeCount: PropTypes.number.isRequired,
};

export default ButtonLike;
