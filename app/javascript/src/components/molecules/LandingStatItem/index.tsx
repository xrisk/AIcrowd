import React from 'react';

import styles from './landingStatItem.module.scss';
const { main, stat, text } = styles;

export type LandingStatItemProps = {
  count: number | string;
  statText: string;
};

const LandingStatItem = ({ count, statText }: LandingStatItemProps) => (
  <>
    <div className={main}>
      <div className={stat}>{count}+</div>
      <div className={text}>{statText}</div>
    </div>
  </>
);

export default LandingStatItem;
