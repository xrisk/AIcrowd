import React from 'react';
import Link from 'src/components/atoms/Link';
import Image from 'next/image';

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
                <img
                  src={image}
                  placeholder="blur"
                  blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                  layout="fill"
                  objectFit="contain"
                  alt="notebook image"
                width="100%"/>
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
