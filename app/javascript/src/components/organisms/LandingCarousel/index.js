import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import cx from 'classnames';
import regexifyString from 'regexify-string';

import AvatarWithTier from 'src/components/atoms/AvatarWithTier';
import styles from './landingCarousel.module.scss';

const {
  slideshowContainer,
  prev,
  next,
  author,
  post,
  mySlides,
  dotContainer,
  authorContainer,
  avatarImg,
  dot,
  active,
  quoteText,
} = styles;

const LandingCarousel = ({ tier, image, loading, borderColor, quotes }) => {
  const [quoteData, getQuoteData] = useState(quotes);
  const [current, setCurrent] = useState(0);
  const [quote, getQuote] = useState(quoteData[current]);

  useEffect(() => getQuote(quoteData[current]), [current, quote]);

  const nextQuote = () => {
    current === quoteData.length - 1 ? setCurrent(0) : setCurrent(current + 1);
  };

  const prevQuote = () => {
    current === 0 ? setCurrent(quoteData.length - 1) : setCurrent(current - 1);
  };

  const dotPicksQuote = e => setCurrent(Number(e.target.id));

  // change quote every 3 seconds;
  useEffect(() => {
    const changeInterval = setInterval(() => {
      nextQuote();
    }, 7000);

    return () => clearInterval(changeInterval);
  }, [nextQuote]);

  return (
    <>
      <section>
        <div className={slideshowContainer}>
          <Slide quote={quote} />
        </div>
        {/* <Dots dotQty={quoteData} current={current} dotPicksQuote={dotPicksQuote} /> */}
      </section>
    </>
  );
  function Slide({ quote }) {
    // Select words which are in between #
    const quoteWithStyling = regexifyString({
      pattern: /\#([^#]+)\#/gm,
      // eslint-disable-next-line react/display-name
      decorator: (match, index) => {
        return (
          <>
            {/* eslint-disable-next-line react/destructuring-assignment */}
            <span style={{ color: '#F0524D' }}>{match?.replace(/#/g, '')}</span>
          </>
        );
      },
      input: quote.quote,
    });

    return (
      <div className={mySlides}>
        <AnimatePresence>
          <div className={quoteText}>
            <motion.q initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
              {quoteWithStyling}
            </motion.q>
          </div>
        </AnimatePresence>
        <div className={authorContainer}>
          <div>
            <AvatarWithTier
              tier={tier}
              image={image}
              loading={loading}
              size="md"
              borderColor={borderColor}
              className={avatarImg}
            />
          </div>
          <div>
            <p className={author}>{quote.author}</p>
            <p className={post}>{quote.post}</p>
          </div>
          <Arrows nextQuote={nextQuote} prevQuote={prevQuote} />
        </div>
      </div>
    );
  }

  function Arrows({ nextQuote, prevQuote }) {
    return (
      <>
        <a onClick={prevQuote} className={prev} id="prev">
          <i className="las la-long-arrow-alt-left"></i>
        </a>
        <a onClick={nextQuote} className={next} id="next">
          <i className="las la-long-arrow-alt-right"></i>
        </a>
      </>
    );
  }

  function Dots({ dotQty, current, dotPicksQuote }) {
    return (
      <div className={dotContainer}>
        {dotQty.map((d, i) => {
          return <span id={i} className={cx({ [active]: current === i }, dot)} key={i} onClick={dotPicksQuote}></span>;
        })}
      </div>
    );
  }
};
export default LandingCarousel;
