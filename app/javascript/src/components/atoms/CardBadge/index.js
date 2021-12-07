import React, { useState } from 'react';
import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';
import PropTypes from 'prop-types';

import styles from './cardBadge.module.scss';

const CardBadge = ({ cardBadge, badgeColor, challengeEndDate }) => {
  const [isHovered, setIsHovered] = useState(false);

  dayjs.extend(relativeTime);
  const endDate = dayjs(challengeEndDate);
  // Time remaining for challenge to finish
  const remainingDays = endDate.diff(dayjs(), 'days');

  return (
    <>
      <div onMouseEnter={() => setIsHovered(true)} onMouseLeave={() => setIsHovered(false)}>
        <span
          className={styles['cardBadge']}
          style={{ background: badgeColor, visibility: cardBadge ? 'visible' : 'hidden' }}>
          Ongoing {isHovered && remainingDays > 0 && `${remainingDays} days left`}
          <span style={{ background: badgeColor }} className={styles['cardTriangle']}></span>
        </span>
      </div>
    </>
  );
};

CardBadge.propTypes = {
  cardBadge: PropTypes.bool,
  badgeColor: PropTypes.string.isRequired,
  challengeEndDate: PropTypes.string,
};

export default CardBadge;
