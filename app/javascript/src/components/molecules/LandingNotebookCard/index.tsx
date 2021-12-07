import React from 'react';

import styles from './landingNotebook.module.scss';

const { mainWrapper, titleText, subWrapper, textWrapper, statusWrapper, time, imgWrapper } = styles;

export type LandingNotebookCardProps = {
  slug: string
  title: string;
  description: string;
  lastUpdated: string;
  image: string;
  author: string;
};

const LandingNotebookCard = ({ slug, title, image, author }: LandingNotebookCardProps) => {
  return (
    <>
      <a href={`/showcase/${slug}`}>
      <div className={mainWrapper}>
        <div className={subWrapper}>
          <div className={imgWrapper}>
            <img src={image}></img>
          </div>
          <div className={textWrapper}>
            <div className={titleText}>{title}</div>
            <div className={statusWrapper}>
              <div className={time}> By: {author}</div>
            </div>
          </div>
        </div>
        {/* <div className={descriptionText}>{description}</div> */}
      </div>
      </a>
    </>
  );
};

export default LandingNotebookCard;
