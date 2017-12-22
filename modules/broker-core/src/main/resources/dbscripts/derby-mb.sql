/*
 * Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

-- WSO2 Message Broker MySQL Database schema --

-- Start of Message Store Tables --

CREATE TABLE MB_METADATA (
                MESSAGE_ID BIGINT,
                EXCHANGE_NAME VARCHAR(512) NOT NULL,
                ROUTING_KEY VARCHAR(512) NOT NULL,
                MESSAGE_METADATA BLOB(65500) NOT NULL,
                PRIMARY KEY (MESSAGE_ID)
);

CREATE TABLE MB_CONTENT (
                MESSAGE_ID BIGINT,
                CONTENT_OFFSET INTEGER,
                MESSAGE_CONTENT BLOB(65500) NOT NULL,
                PRIMARY KEY (MESSAGE_ID, CONTENT_OFFSET),
                FOREIGN KEY (MESSAGE_ID) REFERENCES MB_METADATA (MESSAGE_ID)
                ON DELETE CASCADE
);

CREATE TABLE MB_QUEUE_METADATA (
                QUEUE_NAME VARCHAR(512) NOT NULL,
                QUEUE_AUTO_DELETE BOOLEAN NOT NULL,
                PRIMARY KEY(QUEUE_NAME)
);

CREATE TABLE MB_QUEUE (
                QUEUE_NAME VARCHAR(512) NOT NULL,
                MESSAGE_ID BIGINT,
                PRIMARY KEY (MESSAGE_ID, QUEUE_NAME),
                FOREIGN KEY (MESSAGE_ID) REFERENCES MB_METADATA (MESSAGE_ID)
                ON DELETE CASCADE
);

CREATE TABLE MB_EXCHANGE (
                EXCHANGE_ID INT NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
                EXCHANGE_NAME VARCHAR(512) NOT NULL,
                EXCHANGE_TYPE VARCHAR(512) NOT NULL,
                PRIMARY KEY(EXCHANGE_ID, EXCHANGE_NAME, EXCHANGE_TYPE)
);

CREATE TABLE MB_BINDING (
                EXCHANGE_ID INT NOT NULL,
                QUEUE_NAME VARCHAR(512) NOT NULL,
                ROUTING_KEY VARCHAR(512) NOT NULL,
                MESSAGE_FILTER VARCHAR(512) NOT NULL,
                FOREIGN KEY (EXCHANGE_ID) REFERENCES MB_EXCHANGE (EXCHANGE_ID)
);


INSERT INTO MB_EXCHANGE (EXCHANGE_NAME, EXCHANGE_TYPE)  VALUES('<<default>>', 'direct');
INSERT INTO MB_EXCHANGE (EXCHANGE_NAME, EXCHANGE_TYPE)  VALUES('amq.direct', 'direct');
INSERT INTO MB_EXCHANGE (EXCHANGE_NAME, EXCHANGE_TYPE)  VALUES('amq.topic', 'topic');
