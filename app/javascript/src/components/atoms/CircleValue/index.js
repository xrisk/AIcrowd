import React from 'react';
import cx from 'classnames';
import PropTypes from 'prop-types';

import styles from './circleValue.module.scss';

const CircleValue = ({ value, size, onCard, borderColor }) => {
  const invertColor = borderColor === '#e7e7e7';
  const invertTextColor = invertColor === '#1f1f1f';
  return (
    <>
      <div
        className={cx(styles['circle-value'], { [styles.md]: size === 'md', [styles.onCardCircle]: onCard })}
        style={{ borderColor: borderColor, backgroundColor: invertColor, color: invertTextColor }}>
        <span className={styles['circle-value-content']}> {value}k</span>
      </div>
    </>
  );
};

CircleValue.propTypes = {
  value: PropTypes.number.isRequired,
  size: PropTypes.string,

  /**
   * If it's shown in challenge card used in landing page
   */
  onCard: PropTypes.bool,
  borderColor: PropTypes.string,
};

export default CircleValue;
