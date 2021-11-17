import React from 'react';

import styles from './landingChallengeCard.module.scss';
const { cardItemWrapper, statTitleText } = styles;

type Props = {
  name: string;
  children: React.ReactNode;
};

const ChallengeCardStatItem = ({ name, children }: Props) => {
  return (
    <>
      <div className={cardItemWrapper}>
        <div className={statTitleText}>{name}</div>
        {children}
      </div>
    </>
  );
};
export default ChallengeCardStatItem;
