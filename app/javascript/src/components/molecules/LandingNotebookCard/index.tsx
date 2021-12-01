import React from 'react';
import Link from 'src/components/atoms/Link';

import styles from './landingNotebook.module.scss';

const { mainWrapper, titleText, subWrapper, textWrapper, statusWrapper, time, imgWrapper } = styles;

export type LandingNotebookCardProps = {
  title: string;
  description: string;
  lastUpdated: string;
  image: string;
  author: string;
  url: string;
};

const LandingNotebookCard = ({ title, image, author, url }: LandingNotebookCardProps) => {
  return (
    <>
      <a href={url}>
        <a>
          <div className={mainWrapper}>
            <div className={subWrapper}>
              <div className={imgWrapper}>
                <img src={image}></img>
              </div>
              <div className={textWrapper}>
                <div className={titleText}>{title} </div>
                <div className={statusWrapper}>
                  <div className={time}> By: {author}</div>
                </div>
              </div>
            </div>
          </div>
        </a>
      </a>
    </>
  );
};

export default LandingNotebookCard;
