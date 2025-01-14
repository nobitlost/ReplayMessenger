// MIT License
//
// Copyright 2019 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

@include __PATH__ + "/../ExtendedTestCase.nut"

class ConstructorTestCase extends ImpTestCase {
    logger = null;
    cm = null;
    rm = null;

    function setUp() {
        logger = SPIFlashLogger(SFL_START_TEST, SFL_END_TEST);
        logger.erase();
        cm = ConnectionManager();
    }

    function testExtendedConstructorOptions() {
        const FIRST_MESSAGE_ID_TEST = 6;
        const MAX_RATE_TEST = 12;
        const RESEND_LIMIT_TEST = 16;
        const DEBUG_ENABLE = 1;

        rm = ReplayMessengerExtended(logger, cm, {
            "debug" : DEBUG_ENABLE,
            "ackTimeout" : ACK_TIMEOUT_TEST,
            "firstMsgId" : FIRST_MESSAGE_ID_TEST,
            "maxRate" : MAX_RATE_TEST,
            "resendLimit" : RESEND_LIMIT_TEST
        });

        this.assertEqual(DEBUG_ENABLE, rm._debug);
        this.assertEqual(ACK_TIMEOUT_TEST, rm._ackTimeout);
        this.assertEqual(FIRST_MESSAGE_ID_TEST, rm._nextId);
        this.assertEqual(MAX_RATE_TEST, rm._maxRate);
        this.assertEqual(RESEND_LIMIT_TEST, rm._resendLimit);

        rm = ReplayMessengerExtended(logger, cm);
        this.assertEqual(RM_DEFAULT_DEBUG, rm._debug);
        this.assertEqual(RM_DEFAULT_ACK_TIMEOUT_SEC, rm._ackTimeout);
        this.assertEqual(RM_DEFAULT_FIRST_MESSAGE_ID, rm._nextId);
        this.assertEqual(RM_DEFAULT_MAX_MESSAGE_RATE, rm._maxRate);
        this.assertEqual(RM_DEFAULT_RESEND_LIMIT, rm._resendLimit);
    }

    function testExtendedConstructorArgs() {
        const DEBUG_ENABLE = 1;

        this.assertThrowsError(function() {
            ReplayMessengerExtended(logger, null, {"debug" : DEBUG_ENABLE,
                                         "ackTimeout" : ACK_TIMEOUT_TEST});
        }.bindenv(this), this);

        this.assertThrowsError(function() {
            ReplayMessengerExtended(null, cm, {"debug" : DEBUG_ENABLE,
                                         "ackTimeout" : ACK_TIMEOUT_TEST});
        }.bindenv(this), this);

        this.assertThrowsError(function() {
            ReplayMessengerExtended(null, null, {"debug" : DEBUG_ENABLE,
                                         "ackTimeout" : ACK_TIMEOUT_TEST});
        }.bindenv(this), this);
    }
}
