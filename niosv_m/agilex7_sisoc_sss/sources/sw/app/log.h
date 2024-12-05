// Copyright (C) 2022 Intel Corporation
//
// This software and the related documents are Intel copyrighted materials, and
// your use of them is governed by the express license under which they were
// provided to you ("License"). Unless the License provides otherwise, you may
// not use, modify, copy, publish, distribute, disclose or transmit this
// software or the related documents without Intel's prior written permission.
//
// This software and the related documents are provided as is, with no express
// or implied warranties, other than those that are expressly stated in the
// License.
//
// -----------------------------------------------------------------------------
// File: log.h
// -----------------------------------------------------------------------------
//
// Provides logging macros.

#ifndef LOG_H_
#define LOG_H_

#define logf(fmt, ...) fprintf(stderr, "[%s] " fmt, __func__, ##__VA_ARGS__ )

#endif // LOG_H_