import React from 'react';
import Skeleton from 'react-loading-skeleton';
import PropTypes from 'prop-types';

import styles from './buttonUpvote.module.scss';

const ButtonUpvote = ({ count, loading, compact }) => {
  return (
    <>
      <button
        className={`${styles['btn-upvote']} ${compact && styles.compact}`}
        type="button"
        aria-label="Upvote"
        data-balloon-pos="up">
        <div className={styles['btn-content']}>
          <span className={styles['status-up']}></span>
          <span className={styles['upvote-counter']}>{loading ? <Skeleton width={20} /> : count}</span>
        </div>
      </button>
    </>
  );
};

ButtonUpvote.propTypes = {
  count: PropTypes.number.isRequired,
  loading: PropTypes.bool,
  compact: PropTypes.bool,
};

export default ButtonUpvote;
