import React from 'react';
import PropTypes from 'prop-types';
import { motion, AnimatePresence } from 'framer-motion';

import styles from './filterButton.module.scss';

const FilterButton = ({ name, value, handleChange, showCross }) => {
  return (
    <>
      <motion.div className={styles['checkboxWrapper']} onClick={() => handleChange(name)}>
        <input type="checkbox" id={name} checked={value} readOnly></input>
        <AnimatePresence>
          <motion.label htmlFor="checkboxOne" layout="position">
            {name}
            {showCross && value && (
              <motion.span className={styles['icon-wrapper']}>
                <motion.i
                  className="las la-times"
                  animate={{ scale: 1 }}
                  initial={{ scale: 0 }}
                  exit={{ scale: 0 }}></motion.i>
              </motion.span>
            )}
          </motion.label>
        </AnimatePresence>
      </motion.div>
    </>
  );
};

FilterButton.propTypes = {
  name: PropTypes.string.isRequired,
  value: PropTypes.bool.isRequired,
  handleChange: PropTypes.func.isRequired,
};

export default FilterButton;
