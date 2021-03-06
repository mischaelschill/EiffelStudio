// -*- C++ -*-

// Copyright (C) 2007, 2008, 2009 Free Software Foundation, Inc.
//
// This file is part of the GNU ISO C++ Library.  This library is free
// software; you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software
// Foundation; either version 3, or (at your option) any later
// version.

// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.

// Under Section 7 of GPL version 3, you are granted additional
// permissions described in the GCC Runtime Library Exception, version
// 3.1, as published by the Free Software Foundation.

// You should have received a copy of the GNU General Public License and
// a copy of the GCC Runtime Library Exception along with this program;
// see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
// <http://www.gnu.org/licenses/>.

/** @file parallel/par_loop.h
 *  @brief Parallelization of embarrassingly parallel execution by
 *  means of equal splitting.
 *  This file is a GNU parallel extension to the Standard C++ Library.
 */

// Written by Felix Putze.

#ifndef _GLIBCXX_PARALLEL_PAR_LOOP_H
#define _GLIBCXX_PARALLEL_PAR_LOOP_H 1

#include <omp.h>
#include <parallel/settings.h>
#include <parallel/base.h>
#include <parallel/equally_split.h>

namespace __gnu_parallel
{

/** @brief Embarrassingly parallel algorithm for random access
  * iterators, using hand-crafted parallelization by equal splitting
  * the work.
  *
  *  @param begin Begin iterator of element sequence.
  *  @param end End iterator of element sequence.
  *  @param o User-supplied functor (comparator, predicate, adding
  *  functor, ...)
  *  @param f Functor to "process" an element with op (depends on
  *  desired functionality, e. g. for std::for_each(), ...).
  *  @param r Functor to "add" a single result to the already
  *  processed elements (depends on functionality).
  *  @param base Base value for reduction.
  *  @param output Pointer to position where final result is written to
  *  @param bound Maximum number of elements processed (e. g. for
  *  std::count_n()).
  *  @return User-supplied functor (that may contain a part of the result).
  */
template<typename RandomAccessIterator,
	 typename Op,
	 typename Fu,
	 typename Red,
	 typename Result>
  Op
  for_each_template_random_access_ed(RandomAccessIterator begin,
				     RandomAccessIterator end,
				     Op o, Fu& f, Red r, Result base,
				     Result& output,
				     typename std::iterator_traits
				     <RandomAccessIterator>::
				     difference_type bound)
  {
    typedef std::iterator_traits<RandomAccessIterator> traits_type;
    typedef typename traits_type::difference_type difference_type;
    const difference_type length = end - begin;
    Result *thread_results;
    bool* constructed;

    thread_index_t num_threads =
      __gnu_parallel::min<difference_type>(get_max_threads(), length);

#   pragma omp parallel num_threads(num_threads)
      {
#       pragma omp single
          {
            num_threads = omp_get_num_threads();
            thread_results = static_cast<Result*>(
                                ::operator new(num_threads * sizeof(Result)));
            constructed = new bool[num_threads];
          }

        thread_index_t iam = omp_get_thread_num();

        // Neutral element.
        Result* reduct = static_cast<Result*>(::operator new(sizeof(Result)));

        difference_type
            start = equally_split_point(length, num_threads, iam),
            stop = equally_split_point(length, num_threads, iam + 1);

        if (start < stop)
          {
            new(reduct) Result(f(o, begin + start));
            ++start;
            constructed[iam] = true;
          }
        else
          constructed[iam] = false;

        for (; start < stop; ++start)
          *reduct = r(*reduct, f(o, begin + start));

        thread_results[iam] = *reduct;
      } //parallel

    for (thread_index_t i = 0; i < num_threads; ++i)
        if (constructed[i])
            output = r(output, thread_results[i]);

    // Points to last element processed (needed as return value for
    // some algorithms like transform).
    f.finish_iterator = begin + length;

    delete[] thread_results;
    delete[] constructed;

    return o;
  }

} // end namespace

#endif /* _GLIBCXX_PARALLEL_PAR_LOOP_H */
