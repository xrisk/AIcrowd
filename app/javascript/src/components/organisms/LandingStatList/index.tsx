import React from 'react';

import styles from './landingStatList.module.scss';
const { main } = styles;
import LandingStatItem, { LandingStatItemProps } from 'src/components/molecules/LandingStatItem';

export type LandingStatListProps = {
  statListData: [LandingStatItemProps];
};

const LandingStatList = ({ statListData }: LandingStatListProps) => (
  <>
    <div className={main}>
      {statListData.map((item, i) => {
        const { count, statText } = item;

        return <LandingStatItem count={count} statText={statText} key={i} />;
      })}
    </div>
  </>
);

export default LandingStatList;
